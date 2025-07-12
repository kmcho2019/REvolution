module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Circular buffer implementation
    reg [7:0] memory [0:7];  // 8-entry memory
    reg [2:0] write_ptr = 3'b0;
    
    always @(posedge clk) begin
        if (enable) begin
            memory[write_ptr] <= S;
            write_ptr <= write_ptr + 1;
        end
    end

    // Virtual address calculation (write_ptr - 1 - {A,B,C})
    wire [2:0] read_addr;
    assign read_addr = write_ptr - 1 - {A,B,C};

    // Output selection using the calculated address
    assign Z = memory[read_addr];

endmodule