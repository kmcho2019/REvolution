module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    wire next_state;

    assign next_state = (state & ~(a & b)) | (b & ~a & ~state);
    // q = (state & a) | (b & ~state)
    always @(*) begin
        q = (state & a) | (b & ~state);
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule