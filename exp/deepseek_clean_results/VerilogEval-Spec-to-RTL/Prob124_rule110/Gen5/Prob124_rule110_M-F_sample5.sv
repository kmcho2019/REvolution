module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    wire [511:0] left = {q[510:0], 1'b0};  // q[i+1] with 0 at MSB
    wire [511:0] right = {1'b0, q[511:1]}; // q[i-1] with 0 at LSB

    // Implement Rule 110 for each cell
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule110
            always @(*) begin
                case ({left[i], q[i], right[i]})
                    3'b111: next_q[i] = 1'b0;
                    3'b110: next_q[i] = 1'b1;
                    3'b101: next_q[i] = 1'b1;
                    3'b100: next_q[i] = 1'b0;
                    3'b011: next_q[i] = 1'b1;
                    3'b010: next_q[i] = 1'b1;
                    3'b001: next_q[i] = 1'b1;
                    3'b000: next_q[i] = 1'b0;
                    default: next_q[i] = 1'b0;
                endcase
            end
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule