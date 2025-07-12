module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Synchronize asynchronous reset input to clk domain
reg [1:0] areset_sync;

always @(posedge clk or negedge areset) begin
    if (!areset) begin
        areset_sync <= 2'b00;
    end else begin
        areset_sync <= {areset_sync[0], 1'b1};
    end
end

wire reset_sync = ~areset_sync[1];  // synchronous active-high reset

// State+output encoding:
// bit 0 = output (0=OFF,1=ON)
// bit 1 = auxiliary state bit used for FSM logic (not used explicitly here but can hold 0)
reg [1:0] state_next;
reg [1:0] state;

always @(*) begin
    case(state[0]) // state[0] encodes OFF=0, ON=1
        1'b0: // OFF state (out=0)
            state_next = j ? 2'b01 : 2'b00; // go ON if j=1 else stay OFF
        1'b1: // ON state (out=1)
            state_next = k ? 2'b00 : 2'b01; // go OFF if k=1 else stay ON
        default:
            state_next = 2'b00;
    endcase
end

always @(posedge clk or negedge areset) begin
    if (!areset) begin
        state <= 2'b00; // OFF state with out=0
    end else begin
        state <= state_next;
    end
end

assign out = state[0];

endmodule