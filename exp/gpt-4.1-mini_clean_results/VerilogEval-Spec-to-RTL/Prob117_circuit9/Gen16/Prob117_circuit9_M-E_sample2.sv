module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

// Define states corresponding to the sequence 4->5->6->0->1->2->3->4...
localparam S4 = 3'd4;
localparam S5 = 3'd5;
localparam S6 = 3'd6;
localparam S0 = 3'd0;
localparam S1 = 3'd1;
localparam S2 = 3'd2;
localparam S3 = 3'd3;

reg [2:0] state;

always @(posedge clk) begin
    if (a) begin
        // asynchronously load 4 on a=1
        state <= S4;
    end else begin
        // next state in sequence
        case (state)
            S4: state <= S5;
            S5: state <= S6;
            S6: state <= S0;
            S0: state <= S1;
            S1: state <= S2;
            S2: state <= S3;
            S3: state <= S4;
            default: state <= S4; // handle unknown states by resetting to 4
        endcase
    end
end

always @(*) begin
    q = state;
end

endmodule