module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
localparam [1:0] OFF = 2'b00;
localparam [1:0] ON = 2'b01;

// Define the current state register
reg [1:0] state;

// Define the output
reg out;

// Always block to handle the next state logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to OFF state
        state <= OFF;
    end else begin
        // Next state logic
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF;
        endcase
    end
end

// Always block to handle the output logic
always @(*) begin
    // Output logic
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule