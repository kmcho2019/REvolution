module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg [31:0] shift_reg;  // Assuming 32 bits for simplicity
    reg [4:0] count;       // Counter to keep track of the number of bits
    reg [31:0] temp;       // Temporary register to store the output
    reg start;             // Flag to indicate the start of the conversion
    reg running;           // Flag to indicate the running state of the conversion

    initial begin
        shift_reg = 0;
        count = 0;
        start = 1'b1;
        running = 1'b0;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 0;
            count <= 0;
            start <= 1'b1;
            running <= 1'b0;
            temp <= 0;
        end
        else if (start) begin
            if (x == 1'b1) begin
                shift_reg[0] <= 1'b1;
            end
            else begin
                shift_reg[0] <= 1'b0;
            end
            count <= count + 1;
            start <= 1'b0;
            running <= 1'b1;
        end
        else if (running) begin
            shift_reg <= {shift_reg[30:0], x};
            count <= count + 1;
        end
    end

    always @(posedge clk) begin
        if (~areset && ~running) begin
            temp <= ~shift_reg + 1; // Calculate the 2's complement
            z <= temp[31];          // Output the most significant bit
            temp <= temp << 1;      // Shift left for the next output
            count <= count - 1;
            if (count == 0) begin
                running <= 1'b0;
            end
        end
        else if (running) begin
            z <= 1'b0;
        end
        else if (areset) begin
            z <= 1'b0;
        end
    end
endmodule