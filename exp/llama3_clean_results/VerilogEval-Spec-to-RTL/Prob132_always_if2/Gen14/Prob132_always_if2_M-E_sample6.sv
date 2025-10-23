module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    enum logic [0:0] {operating, shutdown} state, next_state;

    always @(*) begin
        case(state)
            operating: begin
                if (cpu_overheated) begin
                    next_state = shutdown;
                end else begin
                    next_state = operating;
                end
                shut_off_computer = 0;
                keep_driving = ~arrived && ~gas_tank_empty;
            end
            shutdown: begin
                next_state = shutdown;
                shut_off_computer = 1;
                keep_driving = 0;
            end
        endcase
    end

    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        state = next_state;
    end

    initial begin
        state = operating;
    end

endmodule