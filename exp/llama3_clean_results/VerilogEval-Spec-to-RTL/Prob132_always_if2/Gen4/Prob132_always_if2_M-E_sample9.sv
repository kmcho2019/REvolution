module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // 0: shutdown, 1: driving
    reg [1:0] next_state;

    always @(*) begin
        case (state)
            2'b00: begin // shutdown
                shut_off_computer = 1;
                keep_driving = 0;
                if (!cpu_overheated &&!arrived &&!gas_tank_empty) begin
                    next_state = 2'b01; // transition to driving state
                end else begin
                    next_state = 2'b00; // stay in shutdown state
                end
            end
            2'b01: begin // driving
                shut_off_computer = 0;
                keep_driving = 1;
                if (cpu_overheated || arrived || gas_tank_empty) begin
                    next_state = 2'b00; // transition to shutdown state
                end else begin
                    next_state = 2'b01; // stay in driving state
                end
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
                next_state = 2'b00; // default to shutdown state
            end
        endcase
    end

    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        state <= next_state;
    end

endmodule