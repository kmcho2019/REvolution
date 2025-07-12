module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg a_reg;
reg q_reg;

// Register 'a' on clock edges
always @(posedge clock) begin
    a_reg <= a;
end

// q state machine
always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        q_reg <= 1'b0;  // asynchronous reset when clock low and a high
    end
    else if (posedge clock) begin
        if (p && ~q_reg) begin
            q_reg <= 1'b1;  // synchronous set when p was high
        end
    end
end

// p output logic
assign p = q_reg ? p : a_reg;  // hold when q=1, follow a_reg when q=0

// q output
assign q = q_reg;

initial begin
    a_reg = 0;
    q_reg = 0;
end

endmodule