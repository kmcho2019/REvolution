module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] counter;
reg [31:0] internal_register;
reg [0:0] output_register;
reg [0:0] carry;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        counter <= 0;
        internal_register <= 0;
        output_register <= 0;
        carry <= 0;
    end else begin
        if(counter == 0) begin
            internal_register <= x;
            carry <= 0;
            counter <= 1;
            output_register <= 1'b0;
        end else begin
            internal_register <= {internal_register[30:0], x};
            if(internal_register[31] == 1'b1) begin
                carry <= ~x;
            end else begin
                carry <= x;
            end
            counter <= counter + 1;
            output_register <= carry;
        end
    end
end

assign z = output_register;

endmodule