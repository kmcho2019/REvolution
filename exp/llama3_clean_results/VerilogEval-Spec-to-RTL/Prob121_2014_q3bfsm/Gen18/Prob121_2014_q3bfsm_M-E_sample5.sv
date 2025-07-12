module StateModule(
    input clk,
    input reset,
    input request,
    output reg acknowledge,
    output reg [2:0] state
);

reg [2:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;
        acknowledge <= 1'b0;
    end else if (request) begin
        case (current_state)
            3'b000: current_state <= 3'b001;
            3'b001: current_state <= 3'b100;
            3'b010: current_state <= 3'b001;
            3'b011: current_state <= 3'b010;
            3'b100: current_state <= 3'b011;
            default: current_state <= 3'b000;
        endcase
        acknowledge <= 1'b1;
    end else begin
        acknowledge <= 1'b0;
    end
end

assign state = current_state;

endmodule

module OutputModule(
    input [2:0] state,
    output reg z
);

always @(*) begin
    case (state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

wire [2:0] state;
wire request;
wire acknowledge;

StateModule state_module(
    .clk(clk),
    .reset(reset),
    .request(x),
    .acknowledge(acknowledge),
    .state(state)
);

OutputModule output_module(
    .state(state),
    .z(z)
);

endmodule