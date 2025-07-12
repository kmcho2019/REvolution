module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE   = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP   = 3'b100;

    reg [2:0] state;
    reg [7:0] shift_reg;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (!in) begin // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 8'b0;
                        shift_enable <= 1'b1;
                    end
                end
                
                RECEIVE: begin
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    end
                    
                    // Shift-based completion detection
                    if (shift_reg[0]) begin // MSB gets set when complete
                        state <= STOP;
                        shift_enable <= 1'b0;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule