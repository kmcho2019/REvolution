module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // States
    typedef enum logic [1:0] {
        IDLE,
        CALC,
        FINISH
    } state_t;

    // Pipeline registers
    reg [15:0] areg, breg;
    reg [31:0] pp [15:0];  // Partial products
    reg [31:0] sum, carry;
    reg [31:0] final_sum;
    reg zero_flag;
    reg [1:0] pipe_stage;
    state_t state;

    // Generate all partial products in parallel
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            pp[i] = {16'b0, {16{bin[i]}} & areg;
        end
    end

    // Parallel prefix adder (Brent-Kung structure)
    function [31:0] ppa_adder(input [31:0] a, input [31:0] b);
        reg [31:0] g, p, g_out, p_out;
        begin
            // Pre-processing
            g = a & b;
            p = a ^ b;

            // Prefix computation
            for (int i = 1; i < 32; i = i << 1) begin
                for (int j = i; j < 32; j++) begin
                    g_out[j] = g[j] | (p[j] & g[j-i]);
                    p_out[j] = p[j] & p[j-i];
                end
                g = g_out;
                p = p_out;
            end

            // Post-processing
            ppa_adder = p ^ {g[30:0], 1'b0};
        end
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            areg <= 16'b0;
            breg <= 16'b0;
            sum <= 32'b0;
            carry <= 32'b0;
            final_sum <= 32'b0;
            pipe_stage <= 2'b0;
            done <= 1'b0;
            zero_flag <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        zero_flag <= (bin == 16'b0);
                        state <= zero_flag ? FINISH : CALC;
                        pipe_stage <= 2'b0;
                    end
                end

                CALC: begin
                    case (pipe_stage)
                        0: begin
                            // First stage: Reduce partial products using carry-save
                            sum <= pp[0] ^ pp[1];
                            carry <= (pp[0] & pp[1]) << 1;
                            pipe_stage <= 1;
                        end
                        1: begin
                            // Second stage: Continue reduction
                            sum <= sum ^ carry ^ pp[2];
                            carry <= ((sum & carry) | (sum & pp[2]) | (carry & pp[2])) << 1;
                            pipe_stage <= 2;
                        end
                        2: begin
                            // Final addition using PPA
                            final_sum <= ppa_adder(sum, carry);
                            state <= FINISH;
                        end
                    endcase
                end

                FINISH: begin
                    yout <= zero_flag ? 32'b0 : final_sum;
                    done <= 1'b1;
                    if (!start) state <= IDLE;
                end
            endcase
        end
    end

endmodule