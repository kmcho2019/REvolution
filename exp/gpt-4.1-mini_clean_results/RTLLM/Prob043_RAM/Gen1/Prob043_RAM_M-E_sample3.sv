module RAM (
    input                     clk,
    input                     rst_n,
    input                     write_en,
    input      [2:0]          write_addr,
    input      [5:0]          write_data,
    input                     read_en,
    input      [2:0]          read_addr,
    output     [5:0]          read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM Array: 8 words of 6 bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Initialize RAM contents to zero on simulation start and synthesis reset
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Write Operation: synchronous write on clk's rising edge
    always @(posedge clk) begin
        if (!rst_n) begin
            // Optional: no reset of RAM contents here to avoid switching on reset
            // Contents already initialized by initial block or rely on power-up state
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Asynchronous Read Operation: combinational read with read enable gating
    assign read_data = read_en ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule