module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

localparam S0 = 4'b0000;
localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0011;
localparam S4 = 4'b0100;

reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    case(state)
        S0: begin
            if(data) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if(data) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if(~data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if(data) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            next_state = S4;
        end
        default: begin
            next_state = S0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(state == S4) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule