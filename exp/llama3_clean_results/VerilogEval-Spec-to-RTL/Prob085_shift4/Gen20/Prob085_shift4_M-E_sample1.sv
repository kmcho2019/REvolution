// TopModule: Top-level module
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

    reg [3:0] q_reg;
    reg [1:0] state;

    // State machine states
    parameter IDLE = 2'b00;
    parameter LOAD = 2'b01;
    parameter SHIFT = 2'b10;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (load) begin
                    state = LOAD;
                end else if (ena) begin
                    state = SHIFT;
                end else begin
                    state = IDLE;
                end
            end
            LOAD: begin
                state = IDLE;
            end
            SHIFT: begin
                state = IDLE;
            end
            default: begin
                state = IDLE;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 4'b0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    if (load) begin
                        q_reg <= data;
                    end else if (ena) begin
                        q_reg <= {1'b0, q_reg[3:1]};
                    end else begin
                        q_reg <= q_reg;
                    end
                end
                LOAD: begin
                    q_reg <= data;
                end
                SHIFT: begin
                    q_reg <= {1'b0, q_reg[3:1]};
                end
                default: begin
                    q_reg <= q_reg;
                end
            endcase
        end
    end

    // Assign output
    assign q = q_reg;

endmodule