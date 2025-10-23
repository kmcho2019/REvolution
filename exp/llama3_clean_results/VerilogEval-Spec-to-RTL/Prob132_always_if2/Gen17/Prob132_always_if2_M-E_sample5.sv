module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // Two bits to encode four states
    reg [1:0] next_state;

    // State encoding:
    // 00: normal operation
    // 01: cpu overheated
    // 10: arrived
    // 11: gas tank empty

    always @(*) begin
        case (state)
            2'b00: begin // Normal operation
                if (cpu_overheated) next_state = 2'b01;
                else if (arrived) next_state = 2'b10;
                else if (gas_tank_empty) next_state = 2'b11;
                else next_state = 2'b00;
            end
            2'b01: begin // CPU overheated
                next_state = 2'b01;
            end
            2'b10: begin // Arrived
                next_state = 2'b10;
            end
            2'b11: begin // Gas tank empty
                next_state = 2'b11;
            end
            default: next_state = 2'b00;
        endcase
    end

    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        state <= next_state;
    end

    always @(*) begin
        case (state)
            2'b00: begin // Normal operation
                shut_off_computer = 0;
                keep_driving = 1;
            end
            2'b01: begin // CPU overheated
                shut_off_computer = 1;
                keep_driving = 0;
            end
            2'b10: begin // Arrived
                shut_off_computer = 0;
                keep_driving = 0;
            end
            2'b11: begin // Gas tank empty
                shut_off_computer = 0;
                keep_driving = 0;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

endmodule