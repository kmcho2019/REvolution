module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // Using a single bit to represent the state, 1 for B and 0 for A

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if (~x && ~state) begin // A --x=0 (z=0)--> A
            state <= 1'b0;
        end else if (x && ~state) begin // A --x=1 (z=1)--> B
            state <= 1'b1;
        end else if (~x && state) begin // B --x=0 (z=1)--> B
            state <= 1'b1;
        end else if (x && state) begin // B --x=1 (z=0)--> B
            state <= 1'b1;
        end
    end
end

always @(*) begin
    if (~x && ~state) begin // A --x=0 (z=0)--> A
        z = 1'b0;
    end else if (x && ~state) begin // A --x=1 (z=1)--> B
        z = 1'b1;
    end else if (~x && state) begin // B --x=0 (z=1)--> B
        z = 1'b1;
    end else if (x && state) begin // B --x=1 (z=0)--> B
        z = 1'b0;
    end
end

endmodule