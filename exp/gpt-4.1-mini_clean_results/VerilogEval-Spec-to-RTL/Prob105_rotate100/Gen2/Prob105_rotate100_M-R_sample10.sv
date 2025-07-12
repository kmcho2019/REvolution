module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output [99:0] q
);

    reg [99:0] reg_data;
    reg [99:0] next_data;

    // Combinational logic to determine next_data
    always @(*) begin
        if (load) begin
            next_data = data;
        end else begin
            case (ena)
                2'b01: next_data = {reg_data[0], reg_data[99:1]};     // rotate right by 1
                2'b10: next_data = {reg_data[98:0], reg_data[99]};    // rotate left by 1
                default: next_data = reg_data;                         // hold
            endcase
        end
    end

    // State update on clock edge
    always @(posedge clk) begin
        reg_data <= next_data;
    end

    assign q = reg_data;

endmodule