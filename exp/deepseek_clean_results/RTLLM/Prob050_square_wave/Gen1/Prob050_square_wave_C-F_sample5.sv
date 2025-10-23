module square_wave #(
    parameter WIDTH = 8
) (
    input clk,
    input rst_n,        // Active-low reset
    input [WIDTH-1:0] freq,
    output reg wave_out
);

    reg [WIDTH-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state
            count <= {WIDTH{1'b0}};
            wave_out <= 1'b0;
        end
        else if (freq == {WIDTH{1'b0}}) begin
            // Handle zero frequency case
            wave_out <= 1'b0;
            count <= {WIDTH{1'b0}};
        end
        else if (count == (freq - 1)) begin
            // Toggle output and reset counter
            wave_out <= ~wave_out;
            count <= {WIDTH{1'b0}};
        end
        else begin
            // Increment counter
            count <= count + 1'b1;
        end
    end

endmodule