module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
localparam A = 6'd0;
localparam B = 6'd1;
localparam C = 6'd2;
localparam D = 6'd3;
localparam E = 6'd4;
localparam F = 6'd5;

// Current state register
reg [5:0] current_state;

// Initialize state to A on reset
initial current_state = A;

// Update state on positive edge of clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
        z <= 0;
    end else begin
        case (current_state)
            A: begin
                if (w) begin
                    current_state <= A;
                    z <= 0;
                end else begin
                    current_state <= B;
                    z <= 0;
                end
            end
            B: begin
                if (w) begin
                    current_state <= D;
                    z <= 0;
                end else begin
                    current_state <= C;
                    z <= 0;
                end
            end
            C: begin
                if (w) begin
                    current_state <= D;
                    z <= 0;
                end else begin
                    current_state <= E;
                    z <= 0;
                end
            end
            D: begin
                if (w) begin
                    current_state <= A;
                    z <= 0;
                end else begin
                    current_state <= F;
                    z <= 0;
                end
            end
            E: begin
                if (w) begin
                    current_state <= D;
                    z <= 1;
                end else begin
                    current_state <= E;
                    z <= 1;
                end
            end
            F: begin
                if (w) begin
                    current_state <= D;
                    z <= 1;
                end else begin
                    current_state <= C;
                    z <= 1;
                end
            end
        endcase
    end
end

endmodule