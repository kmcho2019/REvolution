module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 0: normal, 1: shut_off, 2: driving, 3: stopped
    reg [1:0] next_state;

    always @(*) begin
        case (state)
            2'b00: begin // normal
                if (cpu_overheated) begin
                    next_state = 2'b01; // shut_off
                end else begin
                    next_state = 2'b00; // normal
                end
            end
            2'b01: begin // shut_off
                next_state = 2'b01; // shut_off
            end
            default: begin
                next_state = 2'b00; // normal
            end
        endcase
    end

    always @(*) begin
        case (state)
            2'b00: begin // normal
                shut_off_computer = 1'b0;
            end
            2'b01: begin // shut_off
                shut_off_computer = 1'b1;
            end
            default: begin
                shut_off_computer = 1'b0;
            end
        endcase
    end

    always @(*) begin
        if (~arrived) begin
            if (~gas_tank_empty) begin
                keep_driving = 1'b1;
            end else begin
                keep_driving = 1'b0;
            end
        end else begin
            keep_driving = 1'b0;
        end
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule