module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] accumulator;
reg [31:0] complement;
reg [31:0] adder;
reg [4:0] counter;
reg start;
reg idle;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        accumulator <= 0;
        complement <= 0;
        adder <= 0;
        counter <= 0;
        start <= 0;
        idle <= 1;
    end else begin
        if(idle) begin
            if(~areset) begin
                idle <= 0;
                start <= 1;
            end
        end else if(start) begin
            accumulator <= {accumulator[30:0], x};
            counter <= counter + 1;
            if(areset) begin
                start <= 0;
                idle <= 1;
            end
        end
    end
end

always @(*) begin
    if(idle || start) begin
        complement = ~accumulator;
        adder = complement + 1;
        z = adder[0];
    end else begin
        z = 0;
    end
end

endmodule