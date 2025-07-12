module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);
    reg [2:0] next_q;

    always @(*) begin
        if (a)
            next_q = 3'd4;  // Jump to state 4 on a=1
        else begin
            case (q)
                3'd0: next_q = 3'd1;
                3'd1: next_q = 3'd2;
                3'd2: next_q = 3'd3;
                3'd3: next_q = 3'd4;
                3'd4: next_q = 3'd5;
                3'd5: next_q = 3'd6;
                3'd6: next_q = 3'd0;
                default: next_q = 3'd0;
            endcase
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end
endmodule