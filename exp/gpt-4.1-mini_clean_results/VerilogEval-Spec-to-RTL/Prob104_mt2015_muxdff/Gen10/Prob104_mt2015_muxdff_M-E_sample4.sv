module TopModule #(
    parameter BIT_IDX = 0
) (
    input        clk,
    input        L,
    input        r_in,
    input        q_in,
    input        q_other1,
    input        q_other2,
    output reg   Q
);

wire next_state;

generate
    if (BIT_IDX == 0) begin
        // q[0] next = (L) ? r_in : q[1]^q[2]
        assign next_state = L ? r_in : (q_other1 ^ q_other2);
    end else if (BIT_IDX == 1) begin
        // q[1] next = (L) ? r_in : q[0]
        assign next_state = L ? r_in : q_other1;
    end else if (BIT_IDX == 2) begin
        // q[2] next = (L) ? r_in : q[0]
        assign next_state = L ? r_in : q_other1;
    end else begin
        // Default to load data if invalid BIT_IDX
        assign next_state = r_in;
    end
endgenerate

always @(posedge clk) begin
    Q <= next_state;
end

endmodule