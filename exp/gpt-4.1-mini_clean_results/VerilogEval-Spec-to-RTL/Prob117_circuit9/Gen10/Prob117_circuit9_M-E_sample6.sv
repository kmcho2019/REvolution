module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

// Next state combinational logic
always @(*) begin
    if (a)
        next_q = 3'd4;
    else begin
        case (q)
            3'd4: next_q = 3'd5;
            3'd5: next_q = 3'd6;
            3'd6: next_q = 3'd0;
            3'd0: next_q = 3'd1;
            3'd1: next_q = 3'd2;
            3'd2: next_q = 3'd3;
            3'd3: next_q = 3'd4;
            default: next_q = 3'd4;
        endcase
    end
end

// Sequential logic: register update on clock edge
always @(posedge clk) begin
    q <= next_q;
end

// Initial state
initial q = 3'd4;

endmodule