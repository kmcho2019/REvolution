module TopModule(
    input         clk,
    input         resetn,
    input         in,
    output        out
);

reg [1:0]        counter;
reg [3:0]        dff_out;
reg             mux_out;

always @(posedge clk) begin
    if (~resetn) begin
        counter <= 2'b00;
        dff_out <= 4'b0000;
    end else begin
        // Ring counter logic
        dff_out[0] <= in;
        dff_out[1] <= dff_out[0];
        dff_out[2] <= dff_out[1];
        dff_out[3] <= dff_out[2];

        // Counter logic
        if (counter == 2'b11) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

always @(posedge clk) begin
    case (counter)
        2'b00: mux_out <= dff_out[3];
        2'b01: mux_out <= dff_out[2];
        2'b10: mux_out <= dff_out[1];
        2'b11: mux_out <= dff_out[0];
    endcase
end

assign out = mux_out;

endmodule