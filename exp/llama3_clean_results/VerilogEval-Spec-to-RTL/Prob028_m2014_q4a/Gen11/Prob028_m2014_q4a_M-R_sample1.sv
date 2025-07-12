module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(ena or d) begin
        if (ena) begin
            q <= d;
        end else begin
            // No action needed here, as q will retain its value
            // However, explicitly assigning q to itself can help in simulation
            q <= q;
        end
    end

endmodule