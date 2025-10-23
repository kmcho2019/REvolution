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
reg [0:0] valid;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        counter <= 0;
        internal_register <= 0;
        output_register <= 0;
        carry <= 0;
        valid <= 0;
    end else begin
        if(counter == 0) begin
            internal_register <= x;
            carry <= 0;
            counter <= 1;
            output_register <= 1'b0;
            valid <= 0;
        end else if (valid == 1'b0) begin
            internal_register <= {internal_register[30:0], x};
            if(carry == 1'b1) begin
                if(x == 1'b1) begin
                    carry <= 1'b1;
                end else begin
                    carry <= 1'b0;
                end
            end else begin
                if(x == 1'b1) begin
                    carry <= 1'b1;
                end else begin
                    carry <= 1'b0;
                end
            end
            counter <= counter + 1;
            if(internal_register[31] == 1'b1) begin
                output_register <= ~x;
            end else begin
                output_register <= x;
            end
            if(counter == 32) begin
                valid <= 1'b1;
            end
        end
    end
end

assign z = (valid == 1'b1)? output_register : 1'b0;

endmodule