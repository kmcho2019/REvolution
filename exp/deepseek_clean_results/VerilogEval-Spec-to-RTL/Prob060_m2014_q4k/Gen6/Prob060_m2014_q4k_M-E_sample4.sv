module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter SHIFT_DIR = 1; // 1 for right shift, 0 for left shift
    reg [3:0] reg_file;
    wire [3:0] next_state;

    // Next state logic with parallel load path (unused) and circular shift
    assign next_state = {reg_file[2:0], in}; // Right shift implementation

    always @(posedge clk) begin
        if (!resetn) begin
            reg_file <= 4'b0;
        end else begin
            reg_file <= next_state;
        end
    end

    assign out = reg_file[3];

endmodule