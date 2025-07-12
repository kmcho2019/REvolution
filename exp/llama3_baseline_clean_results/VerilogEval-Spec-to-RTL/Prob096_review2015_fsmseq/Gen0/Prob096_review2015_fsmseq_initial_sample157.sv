module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

localparam IDLE = 3'b000;
localparam ONEReceived = 3'b001;
localparam ONE_ONEReceived = 3'b010;
localparam ONE_ONE_ZEROReceived = 3'b011;
localparam SEQUENCEFound = 3'b100;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= ONEReceived;
                end else begin
                    state <= IDLE;
                end
            end
            ONEReceived: begin
                if (data) begin
                    state <= ONE_ONEReceived;
                end else begin
                    state <= IDLE;
                end
            end
            ONE_ONEReceived: begin
                if (!data) begin
                    state <= ONE_ONE_ZEROReceived;
                end else begin
                    state <= ONEReceived;
                end
            end
            ONE_ONE_ZEROReceived: begin
                if (data) begin
                    state <= SEQUENCEFound;
                end else begin
                    state <= IDLE;
                end
            end
            SEQUENCEFound: begin
                state <= SEQUENCEFound;
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state == SEQUENCEFound) begin
        start_shifting <= 1;
    end else if (reset) begin
        start_shifting <= 0;
    end
end

endmodule