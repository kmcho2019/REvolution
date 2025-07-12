module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic to determine next_q based on load and ena signals
    always @(*) begin
        if (load) begin
            // Load input data synchronously
            next_q = data;
        end else begin
            case (ena)
                2'b01: 
                    // Rotate right by one bit
                    next_q = {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one bit
                    next_q = {q[98:0], q[99]};
                default:
                    // No rotation, retain current value
                    next_q = q;
            endcase
        end
    end

    // Sequential update of q at the rising edge of clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule