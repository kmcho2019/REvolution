module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg [7:0] out_reg;
    reg done_reg;
    
    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? RECEIVE : IDLE;
            
            RECEIVE: begin
                if (bit_count == 3'b000)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            
            STOP: next_state = in ? IDLE : STOP;
            
            default: next_state = IDLE;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 8'b0;
            out_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    done_reg <= 1'b0;
                    if (next_state == RECEIVE) begin
                        bit_count <= 3'b111;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count != 3'b000) begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        out_reg <= shift_reg;
                        done_reg <= 1'b1;
                    end else begin
                        done_reg <= 1'b0;
                    end
                end
            endcase
        end
    end
    
    assign out_byte = out_reg;
    assign done = done_reg;

endmodule