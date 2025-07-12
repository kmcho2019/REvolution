module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // Shift register implemented with individual D flip-flops connected in a chain
    integer i;
    always @(posedge clk) begin
        if (enable) begin
            Q[0] <= S;
            for (i = 1; i < 8; i = i + 1) begin
                Q[i] <= Q[i-1];
            end
        end
    end

    wire [2:0] sel = {A, B, C};

    // 8-to-1 multiplexer for output Z using nested conditional operators
    assign Z = (sel == 3'd0) ? Q[0] :
               (sel == 3'd1) ? Q[1] :
               (sel == 3'd2) ? Q[2] :
               (sel == 3'd3) ? Q[3] :
               (sel == 3'd4) ? Q[4] :
               (sel == 3'd5) ? Q[5] :
               (sel == 3'd6) ? Q[6] :
                               Q[7];

endmodule