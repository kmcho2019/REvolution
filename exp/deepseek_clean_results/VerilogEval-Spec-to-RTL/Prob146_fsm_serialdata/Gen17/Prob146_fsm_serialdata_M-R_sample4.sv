module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state;
    reg [2:0] bit_count;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default done to 0
            
            case (state)
                IDLE: begin
                    if (!in) begin // Start bit
                        state <= RECEIVE;
                        bit_count <= 3'b111;
                    end
                end
                
                RECEIVE: begin
                    out_byte <= {in, out_byte[7:1]}; // Shift in LSB first
                    if (bit_count == 3'b0) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin // Missing stop bit
                        // Wait for stop bit while staying in STOP state
                        state <= STOP;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule