module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;
    
    reg [2:0] state, next_state;
    reg [23:0] msg_reg;
    reg done_reg;

    // Combinational state logic
    always @(*) begin
        next_state = state;
        done_reg = 1'b0;
        
        case (state)
            IDLE: 
                if (in[3]) next_state = BYTE1;
            BYTE1: 
                next_state = BYTE2;
            BYTE2: begin
                next_state = IDLE;
                done_reg = 1'b1;
            end
            default: 
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_reg <= 24'b0;
        end else begin
            state <= next_state;
            
            case (next_state)
                BYTE1: msg_reg[23:16] <= in;
                BYTE2: msg_reg[15:8] <= in;
                IDLE:  msg_reg[7:0] <= in;
            endcase
        end
    end

    // Output assignments
    assign done = done_reg;
    assign out_bytes = done ? msg_reg : 24'bx;

endmodule