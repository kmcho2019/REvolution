module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

    reg [4:0] count;        // 0-16 counter
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] acc;         // Accumulator
    reg running;            // Active calculation flag
    
    // Barrel shifter: pre-compute all possible shifted values
    wire [31:0] shifted [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted[i] = {16'b0, breg} << i;
        end
    endgenerate

    // Control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
            running <= 1'b0;
        end
        else begin
            if (start && !running) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                acc <= 32'd0;
                count <= 5'd0;
                running <= 1'b1;
            end
            else if (running) begin
                if (count < 16) begin
                    // Accumulate if current bit is set
                    if (areg[count]) begin
                        acc <= acc + shifted[count];
                    end
                    count <= count + 1;
                end
                else begin
                    // Multiplication complete
                    running <= 1'b0;
                end
            end
        end
    end

    // Output assignments
    assign done = (count == 16) && running;
    assign yout = done ? acc : 32'd0;

endmodule