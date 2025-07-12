module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] acc = 0; // Accumulator to store input bits
reg [4:0] count = 0; // Counter to keep track of bits received
reg [31:0] result = 0; // Register to store the result
reg start = 0; // Flag to indicate start of conversion
reg done = 0; // Flag to indicate end of conversion

always @(posedge clk or posedge areset) begin
    if(areset) begin
        acc <= 0;
        count <= 0;
        start <= 0;
        done <= 0;
        result <= 0;
        z <= 0;
    end else begin
        if(~start && ~areset) begin // Start of conversion
            start <= 1;
        end
        if(start && ~done) begin // Accumulate input bits
            acc <= {acc[30:0], x};
            count <= count + 1;
        end
        if(areset && start) begin // End of conversion
            done <= 1;
            // Invert bits and add 1 to get 2's complement
            result <= ~(acc) + 1;
        end
        if(done) begin
            // Output the result bit by bit from MSB to LSB
            if(count > 0) begin
                z <= result[31];
                result <= result << 1;
                count <= count - 1;
            end else begin
                done <= 0;
                start <= 0;
            end
        end
    end
end

endmodule