module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output [3:0] q
);

reg q_ff [3:0];

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (i = 0; i < 4; i = i +1) begin
            q_ff[i] <= 1'b0;
        end
    end else begin
        if (load) begin
            for (i = 0; i < 4; i = i +1) begin
                q_ff[i] <= data[i];
            end
        end else if (ena) begin
            // Shift right: q[3] <= 0, q[i] <= q[i+1] for i=0..2
            q_ff[3] <= 1'b0;
            for (i = 0; i < 3; i = i +1) begin
                q_ff[i] <= q_ff[i+1];
            end
        end
    end
end

assign q = {q_ff[3], q_ff[2], q_ff[1], q_ff[0]};

endmodule