module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_tracker;

always @(posedge clock or negedge clock) begin
    if (clock == 1'b1) begin
        p <= a;
        if (a == 1'b1) begin
            a_tracker <= 1'b1;
            q <= 1'b1;
        end else if (a_tracker == 1'b1) begin
            q <= 1'b1;
        end
    end else begin
        if (a == 1'b1) begin
            q <= 1'b0;
            a_tracker <= 1'b0;
        end else if (a_tracker == 1'b1) begin
            q <= 1'b1;
        end
    end
end

endmodule