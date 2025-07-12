module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define states
reg [1:0] state = 2'b00; // OFF = 2'b00, ON = 2'b01
localparam OFF = 2'b00;
localparam ON = 2'b01;

// State Register Process
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) state <= ON;
            end
            ON: begin
                if (k) state <= OFF;
            end
            default: state <= OFF;
        endcase
    end
end

// Output Logic
always @(*) begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule