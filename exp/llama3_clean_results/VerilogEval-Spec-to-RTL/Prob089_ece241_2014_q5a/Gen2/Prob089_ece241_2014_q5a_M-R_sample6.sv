module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] internal_register;
reg [31:0] counter;
reg output_register;
reg sign_bit;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        internal_register <= 0;
        counter <= 0;
        output_register <= 0;
        sign_bit <= 0;
    end else begin
        if(counter == 0) begin
            internal_register <= x;
            counter <= 1;
            sign_bit <= x;
            output_register <= 1'b0;
        end else begin
            internal_register <= {internal_register[30:0], x};
            if(sign_bit == 1'b1) begin
                if(x == 1'b1) begin
                    output_register <= 1'b1;
                end else begin
                    output_register <= 1'b0;
                end
            end else begin
                output_register <= x;
            end
            counter <= counter + 1;
        end
    end
end

assign z = (sign_bit == 1'b1)? ~internal_register[0] : internal_register[0];

endmodule