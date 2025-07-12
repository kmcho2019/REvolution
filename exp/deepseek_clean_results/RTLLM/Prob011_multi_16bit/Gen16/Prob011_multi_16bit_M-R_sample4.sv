module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        MULTIPLY,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Datapath registers
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    reg [4:0] bit_counter;

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (start) next_state = LOAD;
            LOAD:   next_state = MULTIPLY;
            MULTIPLY: 
                    if (bit_counter == 16) next_state = DONE;
            DONE:   next_state = IDLE;
        endcase
    end

    // State transition and datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            bit_counter <= 5'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;

            case (next_state)
                IDLE: begin
                    acc <= 32'b0;
                    bit_counter <= 5'b0;
                    done <= 1'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                end
                MULTIPLY: begin
                    if (areg[bit_counter]) begin
                        acc <= acc + (breg << bit_counter);
                    end
                    bit_counter <= bit_counter + 1;
                end
                DONE: begin
                    yout <= acc;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule