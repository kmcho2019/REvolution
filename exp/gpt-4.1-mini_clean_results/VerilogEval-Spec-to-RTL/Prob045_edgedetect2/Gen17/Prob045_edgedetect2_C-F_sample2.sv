module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    assign edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        if (|edge_detect) begin        // update only if any bit changed
            anyedge <= edge_detect;   // register XOR output delayed by 1 cycle
            prev_in <= in;            // store current input for next comparison
        end else begin
            anyedge <= 8'b0;          // clear output if no edge detected
            // prev_in remains unchanged to avoid toggling
        end
    end
endmodule