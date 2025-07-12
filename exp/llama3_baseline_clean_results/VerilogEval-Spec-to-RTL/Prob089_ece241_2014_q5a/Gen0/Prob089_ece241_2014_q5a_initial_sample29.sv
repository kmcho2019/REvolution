module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] temp; // to store the input bits
reg [31:0] output; // to store the output bits
reg running; // to indicate the state of the machine

always @(posedge clk or posedge areset) begin
    if (areset) begin
        running <= 0;
        output <= 0;
        temp <= 0;
        z <= 0;
    end else if (~areset) begin
        if (~running) begin
            running <= 1;
            temp <= {31'b0, x};
        end else begin
            temp <= {temp[30:0], x};
            if (x == 0 && temp[31] == 1) begin
                output <= ~temp + 1;
                running <= 0;
            end
        end
    end
end

assign z = output[0];

endmodule