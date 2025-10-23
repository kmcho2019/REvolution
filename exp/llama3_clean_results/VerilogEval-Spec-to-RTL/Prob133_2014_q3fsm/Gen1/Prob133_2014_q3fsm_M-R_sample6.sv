module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [1:0] counter;
reg [1:0] w_count;

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(s) begin
                z = 1'b0;
            end else begin
                z = 1'b0;
            end
        end
        2'b01: begin // State B
            if(counter == 2'b11) begin
                if(w_count == 2'b10) begin
                    z = 1'b1;
                end else begin
                    z = 1'b0;
                end
            end else begin
                z = 1'b0;
            end
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // State A
        counter <= 2'b00;
        w_count <= 2'b00;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to State B
                    counter <= 2'b01;
                    w_count <= 2'b00;
                end
            end
            2'b01: begin // State B
                if(counter == 2'b11) begin
                    state <= 2'b01;
                    counter <= 2'b01;
                    w_count <= 2'b00;
                end else begin
                    if(w) begin
                        w_count <= w_count + 1'b1;
                    end
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

endmodule