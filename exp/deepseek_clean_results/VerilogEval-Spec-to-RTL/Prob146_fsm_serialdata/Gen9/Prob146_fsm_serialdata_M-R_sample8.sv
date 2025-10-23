module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    
    // Combinational done signal
    assign done = (state == STOP) && in;
    
    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:    next_state = in ? IDLE : RECEIVE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (!in) begin
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin
                        bit_count <= 3'b0;
                    end
                end
            endcase
        end
    end
    
    // Output byte assignment (combinational)
    always @(*) begin
        out_byte = (done) ? shift_reg : 8'b0;
    end

endmodule