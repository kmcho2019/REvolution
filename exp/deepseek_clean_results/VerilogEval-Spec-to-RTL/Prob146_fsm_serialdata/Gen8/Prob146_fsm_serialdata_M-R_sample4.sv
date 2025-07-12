module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [7:0] shift_reg;
    reg receiving_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            receiving_done <= 1'b0;
        end else begin
            done <= 1'b0; // Default value
            
            case (state) // synthesis parallel_case
                IDLE: begin
                    if (!in) begin // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 8'b0;
                        receiving_done <= 1'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // LSB first
                    
                    // Check if all 8 bits received
                    if (shift_reg[0]) begin // Use MSB as flag
                        state <= STOP;
                        receiving_done <= 1'b1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= shift_reg;
                        done <= receiving_done;
                        state <= IDLE;
                    end else begin
                        // Wait for stop bit without changing state
                        receiving_done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule