module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    integer i;
    reg [99:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                2'b10: begin // rotate left by one
                    for (i = 0; i < 100; i = i + 1) begin
                        // bit i gets bit (i+1)%100
                        next_q[i] = q[(i + 1) % 100];
                    end
                end
                2'b01: begin // rotate right by one
                    for (i = 0; i < 100; i = i + 1) begin
                        // bit i gets bit (i-1+100)%100
                        next_q[i] = q[(i + 99) % 100];
                    end
                end
                default: begin // hold
                    next_q = q;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule