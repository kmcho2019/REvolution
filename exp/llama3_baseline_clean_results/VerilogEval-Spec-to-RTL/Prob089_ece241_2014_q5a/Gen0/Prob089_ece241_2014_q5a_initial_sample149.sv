module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] count; // Counter to store the number of bits received so far
reg [31:0] input_number; // Register to store the input number
reg [31:0] output_number; // Register to store the 2's complement
reg running; // Flag to indicate whether the machine is in the 'running' state

initial begin
    count = 0;
    input_number = 0;
    output_number = 0;
    running = 0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        count <= 0;
        input_number <= 0;
        output_number <= 0;
        running <= 0;
        z <= 0;
    end else begin
        if (~running) begin
            if (count == 0) begin
                running <= 1;
                input_number <= x;
                count <= 1;
            end else begin
                running <= 0;
            end
        end else begin
            input_number <= {input_number[30:0], x};
            count <= count + 1;
            if (count == 32) begin
                running <= 0;
                output_number <= ~input_number + 1;
                z <= output_number[0];
            end else begin
                z <= 0;
            end
        end
    end
end

endmodule