module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam STATE_A = 2'b00;
    localparam STATE_B = 2'b01;
    localparam STATE_C = 2'b10;
    localparam STATE_D = 2'b11;
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    // Continuous priority evaluation
    wire grant_0 = (r[0] & (current_state == STATE_A)) | (current_state == STATE_B);
    wire grant_1 = (!r[0] & r[1] & (current_state == STATE_A)) | (current_state == STATE_C);
    wire grant_2 = (!r[0] & !r[1] & r[2] & (current_state == STATE_A)) | (current_state == STATE_D);
    
    // State transition logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else if (r[2]) next_state = STATE_D;
                else next_state = STATE_A;
            end
            STATE_B: begin
                if (r[0]) next_state = STATE_B;
                else next_state = STATE_A;
            end
            STATE_C: begin
                if (r[1]) next_state = STATE_C;
                else next_state = STATE_A;
            end
            STATE_D: begin
                next_state = STATE_A; // Device 2 can't hold grant (per spec)
            end
            default: next_state = STATE_A;
        endcase
    end
    
    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Output logic (combinational)
    assign g[0] = grant_0;
    assign g[1] = grant_1;
    assign g[2] = grant_2;

endmodule