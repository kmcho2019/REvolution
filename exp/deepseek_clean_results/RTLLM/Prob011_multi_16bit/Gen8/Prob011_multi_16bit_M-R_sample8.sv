module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    reg running;

    // Pre-compute all shifted versions of breg
    wire [31:0] shifted_b [0:15];
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = {16'b0, breg} << i;
        end
    endgenerate

    // Counter and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                count <= 4'b0;
                running <= 1'b1;
            end else if (running) begin
                if (count < 15) begin
                    // Accumulate if current bit is set
                    acc <= acc + (areg[count] ? shifted_b[count] : 32'b0);
                    count <= count + 1;
                end else begin
                    // Final accumulation and stop
                    acc <= acc + (areg[count] ? shifted_b[count] : 32'b0);
                    running <= 1'b0;
                end
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (count == 15) && running;

endmodule