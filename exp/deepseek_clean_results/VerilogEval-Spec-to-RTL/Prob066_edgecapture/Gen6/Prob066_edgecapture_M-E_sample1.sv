module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Define state encoding
    localparam IDLE = 2'b00;
    localparam DETECTED = 2'b01;
    localparam RESET = 2'b10;

    // State registers for each bit
    reg [1:0] bit_state [0:31];
    reg [31:0] in_prev;

    // Output assignment
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : output_gen
            assign out[i] = (bit_state[i] == DETECTED);
        end
    endgenerate

    integer j;
    always @(posedge clk) begin
        if (reset) begin
            for (j = 0; j < 32; j = j + 1) begin
                bit_state[j] <= RESET;
            end
            in_prev <= 32'b0;
        end
        else begin
            in_prev <= in;
            for (j = 0; j < 32; j = j + 1) begin
                case (bit_state[j])
                    IDLE: begin
                        if (in_prev[j] && !in[j]) begin
                            bit_state[j] <= DETECTED;
                        end
                    end
                    DETECTED: begin
                        // Stay in detected state until reset
                        bit_state[j] <= DETECTED;
                    end
                    RESET: begin
                        bit_state[j] <= IDLE;
                    end
                endcase
            end
        end
    end

    // Initialize all bits to IDLE state
    initial begin
        for (j = 0; j < 32; j = j + 1) begin
            bit_state[j] = IDLE;
        end
    end

endmodule