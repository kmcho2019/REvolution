module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    if (ena) begin
        q <= d;
    end else begin
        // This line is just for clarity, indicating q retains its value
        // In Verilog, a reg retains its value unless explicitly changed
        // However, for synthesizability and clarity, it's good practice to
        // explicitly handle all cases, even if it doesn't change the functionality
        q <= q;
    end
end

endmodule