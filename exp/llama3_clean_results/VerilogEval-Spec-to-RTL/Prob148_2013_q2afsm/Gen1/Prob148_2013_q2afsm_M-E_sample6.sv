module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
reg [1:0] state;
reg [1:0] next_state;

// Priority encoder
wire [1:0] priority;
assign priority = (r[0] == 1'b1) ? 2'b00 : ((r[1] == 1'b1) ? 2'b01 : ((r[2] == 1'b1) ? 2'b10 : 2'b00));

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            if (priority == 2'b00) begin
                next_state = 2'b00; // No request
            end else if (priority == 2'b01) begin
                next_state = 2'b01; // Device 0 requesting
            end else if (priority == 2'b10) begin
                next_state = 2'b10; // Device 1 requesting
            end else if (priority == 2'b11) begin
                next_state = 2'b11; // Device 2 requesting (not needed)
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Device 0 still requesting
            end else begin
                next_state = 2'b00; // Device 0 not requesting
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Device 1 still requesting
            end else begin
                next_state = 2'b00; // Device 1 not requesting
            end
        default:
            next_state = 2'b00; // Initial state
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to State A
    end else begin
        state <= next_state;
    end
end

// FSM outputs
assign g[0] = (state == 2'b01); // g[0] is 1 in State B
assign g[1] = (state == 2'b10); // g[1] is 1 in State C
assign g[2] = (state == 2'b11); // g[2] is 1 in State D (not needed)

endmodule