module TopModule(
    input        clk,
    input        aresetn,
    input        x,
    output reg   z  // Declare z as a reg
);

reg [1:0] state;
reg [1:0] nextState;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
            z = 1'b0;
        end
        S1: begin
            if (~x) begin
                nextState = S2;
            end else begin
                nextState = S1;
            end
            z = 1'b0;
        end
        S2: begin
            if (x) begin
                nextState = S1;
                z = 1'b1;
            end else begin
                nextState = S0;
                z = 1'b0;
            end
        end
        default: begin
            nextState = S0;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
        z <= 1'b0; // Reset z to 0 on asynchronous reset
    end else begin
        state <= nextState;
    end
end

endmodule