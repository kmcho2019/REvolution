module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] memory;
    reg [2:0] write_ptr;
    wire [2:0] read_addr = {A, B, C};
    
    // Serial write process with counter
    always @(posedge clk) begin
        if (enable) begin
            memory[write_ptr] <= S;
            write_ptr <= write_ptr + 1;
        end
    end
    
    // Direct read access
    assign Z = memory[read_addr];
    
    // Initialization
    initial begin
        write_ptr = 3'b0;
        memory = 8'b0;
    end
endmodule