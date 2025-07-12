module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output [3:0] q
);

reg ff0, ff1, ff2, ff3;

// Asynchronous reset for all flip-flops
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ff0 <= 1'b0;
        ff1 <= 1'b0;
        ff2 <= 1'b0;
        ff3 <= 1'b0;
    end else begin
        if (load) begin
            ff3 <= data[3];
            ff2 <= data[2];
            ff1 <= data[1];
            ff0 <= data[0];
        end else if (ena) begin
            ff3 <= 1'b0;     // Insert zero into MSB
            ff2 <= ff3;
            ff1 <= ff2;
            ff0 <= ff1;
        end
        // else hold current values
    end
end

assign q = {ff3, ff2, ff1, ff0};

endmodule