module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the number of states
localparam NUM_STATES = 4;

// Counter to keep track of the current state
reg [1:0] count;

// Next state logic and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        count <= 2'b00;
        out <= 0;
    end else begin
        case (count)
            2'b00: if (!in) count <= 2'b00; else count <= 2'b01;
            2'b01: if (!in) count <= 2'b10; else count <= 2'b01;
            2'b10: if (!in) count <= 2'b00; else count <= 2'b11;
            2'b11: if (!in) count <= 2'b10; else count <= 2'b01;
            default: count <= 2'b00;
        endcase
        
        case (count)
            2'b00, 2'b01, 2'b10: out <= 0;
            2'b11: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule